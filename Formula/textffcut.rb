class Textffcut < Formula
  include Language::Python::Virtualenv

  desc "Apple Silicon Mac専用バッチ文字起こしCLIツール"
  homepage "https://note.com/coidemo"
  url "https://github.com/Coidemo/TextffCut/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "c695331a96ac6db8e7badf91180a575398c072357f939b76ab00eae7ea3b3b03"
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
