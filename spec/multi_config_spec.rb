# coding: utf-8
require 'spec_helper'

describe MultiConfig do
  it 'has a version number' do
    expect(MultiConfig::VERSION).not_to be nil
  end

  it 'does something useful' do

    # initialilze data (Simple, Simple, Environment)
    config = MultiConfig::MultiConfig.instance.add(
      configs: {
        simple1: MultiConfig::SimpleConfig.new(
          'key1' => '1of1',
          'key2' => '2of1'
        ),
        simple2: MultiConfig::SimpleConfig.new(
          'key1' => 'two of one',
          'key2' => 'two of two'
        ),
        env:     MultiConfig::EnvConfig.new
      })

    expect(config.names.count).to eq(3)
    expect(config.names[0]).to eq(:simple1)
    expect(config.names[1]).to eq(:simple2)
    expect(config.names[2]).to eq(:env)

    # :key1 is top order.
    expect(config['key1']).to eq('1of1')

    # :key2 is same
    expect(config['key2']).to eq('2of1')

    # HOME is only :env.
    expect(config['HOME']).to eq(ENV['HOME'])

    # list who has config['HOME'].
    puts config.values('HOME')

    # change order
    config.change_order(names: [:env, :simple2, :simple1])
    expect(config['key1']).to eq('two of one')
    expect(config['key2']).to eq('two of two')

    # get config value by key with configname
    expect(config.value(:simple1)['key1']).to eq('1of1')
    expect(config.value(:simple1)['key2']).to eq('2of1')
    expect(config.value(:env)['key1']).to eq(nil)
  end
end
