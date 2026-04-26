class Textffcut < Formula
  include Language::Python::Virtualenv

  desc "Apple Silicon Mac専用バッチ文字起こしCLIツール"
  homepage "https://note.com/coidemo"
  url "https://github.com/Coidemo/TextffCut/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "34fa5b589709e0cbf30e27174d588e4e79cddc773dc82026a26a876e92c515e6"
  license "Proprietary"

  depends_on arch: :arm64
  depends_on "python@3.11"
  depends_on "ffmpeg"

  def install
    virtualenv_create(libexec, "python3.11")
    # ソースをlibexecに退避（post_installで使用、buildpathはinstall後に消える）
    (libexec/"src").install Dir[buildpath/"*"]
    # bin.install_symlink は post_install 後に実行する (順序の罠)
    # 理由: install フェーズの時点で libexec/bin/textffcut はまだ存在しない
    # (post_install の `pip install` で初めて生成される). その状態で
    # install_symlink を呼ぶと broken symlink が作られ、brew link 段階で
    # /opt/homebrew/bin/textffcut が作成されない.
  end

  def post_install
    # post_installフェーズではHomebrewのdylib relocationが実行されないため、
    # cryptographyの.soヘッダーパディング不足エラーを回避できる
    system libexec/"bin/python3", "-m", "pip", "install",
           "--quiet", (libexec/"src").to_s
    # textffcut entry point が pip install で生成された後に symlink を作る
    bin.install_symlink libexec/"bin/textffcut"
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
