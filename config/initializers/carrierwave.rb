unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_ACCESS_KEY_ID'],
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'rank-top-32010'
    config.cache_storage = :fog
  end
end
