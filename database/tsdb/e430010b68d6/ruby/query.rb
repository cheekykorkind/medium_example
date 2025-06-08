require 'influxdb-client'
require 'benchmark'

INFLUX_URL = ENV['INFLUX_URL']
INFLUX_TOKEN = ENV['INFLUXDB_TOKEN']
INFLUX_ORG = ENV['INFLUXDB_ORGANIZATION']
INFLUX_BUCKET = ENV['INFLUXDB_BUCKET']

def query_result_count(query_api, query_str)
  result_count = 0

  query_api.query(query: query_str).each do |table|
    table.records.each do |record|
      result_count += 1
      puts "    - point #{result_count}: #{record.values.inspect}" if result_count <= 1
    end
  end

  if result_count == 0
    puts '  no result'
  else
    puts "  series cardinality count :#{result_count}"
  end
end

# ===================================================================
client = InfluxDB2::Client.new(
  INFLUX_URL,
  INFLUX_TOKEN,
  org: INFLUX_ORG,
  use_gzip: true,
  use_ssl: INFLUX_URL.start_with?('https')
)

query_api = client.create_query_api

QUERY_LOW_CARDINALITY = <<~FLUX
  from(bucket: "basebucket")
    |> range(start: -48h)
    |> filter(fn: (r) => r._measurement == "sensor_metrics_low_cardinality")
    |> filter(fn: (r) => r._field == "temperature")
    |> group(columns: ["sensor_id"])
    |> mean()
    |> yield(name: "low_cardinality_mean")
FLUX

QUERY_ALL_HIGH_CARDINALITY = <<~FLUX
  from(bucket: "basebucket")
    |> range(start: -48h)
    |> filter(fn: (r) => r._measurement == "sensor_metrics_high_cardinality")
    |> filter(fn: (r) => r._field == "temperature")
    |> group(columns: ["sensor_id"])
    |> mean()
    |> yield(name: "high_cardinality_mean")
FLUX

puts '=================================================='
puts 'Start Benchmark'
puts '=================================================='
puts "INFLUX_URL: #{INFLUX_URL}"
puts "INFLUX_ORG: #{INFLUX_ORG}"
puts "\n"

begin
  Benchmark.bm(35) do |benchmark|
    benchmark.report('sensor_metrics_low_cardinality:') do
      query_result_count(query_api, QUERY_LOW_CARDINALITY)
    end

    benchmark.report('sensor_metrics_high_cardinality:') do
      query_result_count(query_api, QUERY_ALL_HIGH_CARDINALITY)
    end
  end

  client.close!
  puts "\n\nBenchmark done."
end
