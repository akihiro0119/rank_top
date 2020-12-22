unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAXA6QJ4I3A656FON6',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'rank-top-32010'
    config.cache_storage = :fog
  end
end
