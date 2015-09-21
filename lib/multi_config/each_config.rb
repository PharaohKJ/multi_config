# coding: utf-8

module MultiConfig
  # MultiConfigで管理されるConfigはこのModuleをincludeすること
  module EachConfig
    # need override implement reload config from source
    def refresh
    end

    def dump
      YAML.dump(@my_conf)
    end

    # implement config[_k] or nil
    def [](k)
      @my_conf[k]
    end

    # implement config[_k] = _v
    def []=(k, v)
      @my_conf[k] = v
    end
  end
end
