# coding: utf-8

module MultiConfig
  require 'yaml'
  require 'singleton'
  class MultiConfig
    attr_reader :configs
    include Singleton
    # Configの追加
    def add(name: nil, config: nil, configs: {})
      @configs = {} if @configs.nil?
      configs.merge(name: name, config: config).each do |k, v|
        next self unless v.is_a? EachConfig
        @configs[k] = v
      end
      self
    end

    # get Config List
    def names
      @configs.keys
    end

    alias_method :order, :names

    def change_order(names: [], name: nil)
      names << name
      names.concat @configs.keys
      new_config = {}
      names.uniq.each do |k|
        new_config[k] = @configs[k] unless @configs[k].nil?
      end
      @configs = new_config
      self
    end

    def current
      @configs[@configs.keys[0]] if name.nil?
    end

    def value(name)
      @configs[name] unless name.nil?
    end

    def [](k)
      @configs.each { |_k, v|  return v[k] unless v[k].nil? }
      nil
    end

    def []=(k, v)
      current[k] = v
    end

    def refresh
      @configs.each { |_k, v| v.refresh }
    end

    def values(k)
      out = {}
      @configs.each { |n, v| out[n] = v[k] }
      out
    end
  end
end
