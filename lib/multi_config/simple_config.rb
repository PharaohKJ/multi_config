# coding: utf-8

module MultiConfig
  # Hashを用いた設定のConfig例
  class SimpleConfig < Hash
    include EachConfig
    def initialize(conf)
      @my_conf = conf
    end
  end
end
