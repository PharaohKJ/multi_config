# MultiConfig

設定をどこから読むのか？ということが多い、主に考えられるものとして

1. 環境変数
2. コマンドラインパラメータ
3. プロセス実行中に動的されない設定ファイル
4. プロセス実行中に動的に更新される設定ファイル、Databaseなど
5. 設定されてない場合のデフォルト値

などがあげられる。これらの値をそれぞれ管理(読み込み、参照)し、使う方としては
その優先度を意識しなくてすむ設定classが欲しかった。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'multi_config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_config

## Usage

### 1. `MultiConfig::EachConfig`を`include`したclassを作成する

```ruby
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
```

### 2. MultiConfig.instance.addで名前を指定して追加する

最初に追加したほうが優先度が高い。

```ruby
#config設定
config = MultiConfig::MultiConfig.instance.add(
  configs: {
    simple1: MultiConfig::SimpleConfig.new('key1' => '1of1', 'key2' =>  '2of1'),
    simple2: MultiConfig::SimpleConfig.new('key1' => 'two of one', 'key2' => 'two of two'),
    env:     MultiConfig::EnvConfig.new
  })

```


### 3. アクセッサ[]でアクセスする

```ruby
puts config['key1']
```


### その他

```ruby
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
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/multi_config. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

