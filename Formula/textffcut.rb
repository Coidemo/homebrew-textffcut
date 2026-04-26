class Textffcut < Formula
  include Language::Python::Virtualenv

  desc "Apple Silicon Mac専用バッチ文字起こしCLIツール"
  homepage "https://note.com/coidemo"
  url "https://github.com/Coidemo/TextffCut/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "5c6e00829dd417f0d411caf4fe1d25a45ea379a2af3777932ffcc2dc1dda6384"
  license "Proprietary"

  depends_on arch: :arm64
  depends_on "python@3.11"
  depends_on "ffmpeg"

  def install
    virtualenv_create(libexec, "python3.11")
    # ソースをlibexecに退避（post_installで使用、buildpathはinstall後に消える）
    (libexec/"src").install Dir[buildpath/"*"]
    bin.install_symlink libexec/"bin/textffcut"
  end

  def post_install
    # post_installフェーズではHomebrewのdylib relocationが実行されないため、
    # cryptographyの.soヘッダーパディング不足エラーを回避できる
    system libexec/"bin/python3", "-m", "pip", "install",
           "--quiet", (libexec/"src").to_s
  end

  def caveats
    <<~EOS
      textffcut コマンドが見つからない場合、以下を ~/.zshrc に追加してください:

        eval "$(/opt/homebrew/bin/brew shellenv)"

      追加後、ターミナルを再起動するか以下を実行:

        source ~/.zshrc

      初回セットアップ:

        textffcut activate XXXXX-XXXXX-XXXXX-XXXXX
        textffcut gui
    EOS
  end

  test do
    assert_match "textffcut", shell_output("#{bin}/textffcut --help 2>&1")
  end
end
