require 'influxdb-client'

INFLUX_URL = ENV['INFLUX_URL']
INFLUX_TOKEN = ENV['INFLUXDB_TOKEN']
INFLUX_ORG = ENV['INFLUXDB_ORGANIZATION']
INFLUX_BUCKET = ENV['INFLUXDB_BUCKET']

TOTAL_POINTS = 100_000
BATCH_SIZE = 5_000

# ===================================================================

client = InfluxDB2::Client.new(
  INFLUX_URL,
  INFLUX_TOKEN,
  org: INFLUX_ORG,
  bucket: INFLUX_BUCKET,
  precision: InfluxDB2::WritePrecision::SECOND,
  use_gzip: true,
  use_ssl: false
)

write_options = InfluxDB2::WriteOptions.new(
  write_type: :asynchronous,
  batch_size: 5000,
  flush_interval: 1000
)
write_api = client.create_write_api(write_options: write_options)

def generate_and_write_data(write_api, measurement_name, total_points, high_cardinality: false)
  puts "Measurement '#{measurement_name}'"
  puts '--------------------------------------------------'

  low_cardinality_sensors = ('l-sensor-01'..'l-sensor-03').to_a.freeze

  points_batch = []
  (1..total_points).each do |i|
    sensor_id = high_cardinality ? "h-sensor-#{i}" : low_cardinality_sensors.sample

    point = {
      name: measurement_name,
      tags: {
        sensor_id: sensor_id
      },
      fields: {
        temperature: rand(15.0..35.0).round(2),
        humidity: rand(40.0..65.0).round(2)
      },
      time: Time.now.utc.to_i - (total_points - i)
    }
    points_batch << point

    next unless points_batch.size >= BATCH_SIZE

    write_api.write(data: points_batch)
    write_api.close!
    points_batch.clear
  end

  unless points_batch.empty?
    write_api.write(data: points_batch)
    write_api.close!
  end

  puts "\n'#{measurement_name}' done!"
end

begin
  puts '=================================================='
  puts 'write sensor_metrics_low_cardinality'
  puts '=================================================='
  generate_and_write_data(
    write_api,
    'sensor_metrics_low_cardinality',
    TOTAL_POINTS,
    high_cardinality: false
  )

  puts "\n"
  puts '=================================================='
  puts 'write sensor_metrics_high_cardinality'
  puts '=================================================='
  generate_and_write_data(
    write_api,
    'sensor_metrics_high_cardinality',
    TOTAL_POINTS,
    high_cardinality: true
  )
ensure
  client.close!
  puts "\nDone."
end
