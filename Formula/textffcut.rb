class Textffcut < Formula
  include Language::Python::Virtualenv

  desc "Apple Silicon Mac専用バッチ文字起こしCLIツール"
  homepage "https://note.com/coidemo"
  url "https://github.com/Coidemo/TextffCut/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "6a892025be68687d2efb50761b1ab4d7bcbbffbe0610330dfefe910a51a26ec6"
  license "Proprietary"

  depends_on arch: :arm64
  depends_on "python@3.11"
  depends_on "ffmpeg"

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install buildpath
    bin.install_symlink libexec/"bin/textffcut"
  end

  test do
    assert_match "textffcut", shell_output("#{bin}/textffcut --help 2>&1")
  end
end
