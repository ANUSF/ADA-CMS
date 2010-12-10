module Nesstar
  module AtsidaConfig
    if RAILS_ENV == "development"
      $datasets_file = "config/atsida_integration_dev.yml"
    else
      $datasets_file = "config/atsida_integration.yml"
    end

    $tmp_dir = File.dirname(__FILE__) + "/../../tmp"
    $nesstar_dir = "#{$tmp_dir}/nesstar"
    $rss_dir = "#{$tmp_dir}/rss/"
    $xml_dir = "#{$nesstar_dir}/xml/"
  end
end