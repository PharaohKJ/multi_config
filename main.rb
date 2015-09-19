# coding: utf-8

module MultiConfig
  require 'yaml'
  require 'singleton'
  class MultiConfig
    attr_reader :configs
    include Singleton
    # Configの追加
    def add(name: nil, config: nil, configs: nil)
      @configs = {} if @configs.nil?
      if configs.nil?
        return self unless config.is_a? EachConfig
        @configs[name] = config
        self
      else
        return self unless configs.is_a? Hash
        configs.each do |k, v|
          add(name: k, config: v)
        end
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

  # Hashを用いた設定のConfig例
  class SimpleConfig < Hash
    include EachConfig
    def initialize(conf)
      @my_conf = conf
    end

    # refreshをoverrideする例
    def refresh
      puts 'override refresh!'
    end
  end

  # 環境変数を参照するConfigの例
  class EnvConfig
    include EachConfig

    # []をoverrideしてrubyのENV[]を返す
    def [](k)
      ENV[k]
    end

    def []=(k, v)
      ENV[k] = v
    end
  end
end

#config設定
config = MultiConfig::MultiConfig.instance.add(
  configs: {
    simple1: MultiConfig::SimpleConfig.new('key1' => '1of1', 'key2' =>  '2of1'),
    simple2: MultiConfig::SimpleConfig.new('key1' => 'two of one', 'key2' => 'two of two'),
    env:     MultiConfig::EnvConfig.new
  })

# env一覧を表示
puts config.names

# :key1は先頭が:simple1のkey1なので'value1'
puts config['key1']

# :key2も同様なので2
puts config['key2']

# HOMEはenvにしかないので、:envのものが表示される
puts config['HOME']

# 'HOME'がどのように取得されているかみてみる
puts config.values('HOME')

# 順序を変えてみる
config.change_order(names: [:env, :simple2, :simple1])

# 参照してみる(3, value4となる)
puts config['key1']
puts config['key2']

# 自分で順序を指定してとる
puts config.value(:simple1)['key1']

puts config.value(:env)['key1']
