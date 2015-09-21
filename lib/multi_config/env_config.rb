# coding: utf-8

module MultiConfig
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
