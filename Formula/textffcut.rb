class Textffcut < Formula
  include Language::Python::Virtualenv

  desc "Apple Silicon Mac専用バッチ文字起こしCLIツール"
  homepage "https://note.com/coidemo"
  url "https://github.com/Coidemo/TextffCut/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "746731816d39fb301161db87692ff60170edfbf0b781a5d47b4f76377652a810"
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
