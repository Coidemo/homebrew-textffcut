class Textffcut < Formula
  include Language::Python::Virtualenv

  desc "Apple Silicon Mac専用バッチ文字起こしCLIツール"
  homepage "https://note.com/coidemo"
  url "https://github.com/Coidemo/TextffCut/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "dd856d9319f270285fdab42b8bae1c86a9a121567efe32e67e87f79178563ec5"
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
