class Textffcut < Formula
  include Language::Python::Virtualenv

  desc "Apple Silicon Mac専用バッチ文字起こしCLIツール"
  homepage "https://note.com/coidemo"
  url "https://github.com/Coidemo/TextffCut/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "4a27da5d0484b5711144ba7621a6f2734c614a7234d6025544eb6bcaee8b5e46"
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

  test do
    assert_match "textffcut", shell_output("#{bin}/textffcut --help 2>&1")
  end
end
