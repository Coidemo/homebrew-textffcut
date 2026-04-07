class Textffcut < Formula
  include Language::Python::Virtualenv

  desc "Apple Silicon Mac専用バッチ文字起こしCLIツール"
  homepage "https://note.com/coidemo"
  url "https://github.com/Coidemo/TextffCut/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "f34ed3d60ea057727401ed2019b8f2ffcdd3dc38a82a909952490976c35b1dd2"
  license "Proprietary"

  depends_on arch: :arm64
  depends_on "python@3.11"
  depends_on "ffmpeg"

  def install
    venv = virtualenv_create(libexec, "python3.11")
    # venv.pip_install は --no-deps のため依存が入らない。
    # torch/mlx 等の大型依存は resource 化が非現実的なので
    # python -m pip で依存ごとインストールする。
    system libexec/"bin/python3", "-m", "pip", "install", buildpath.to_s
    bin.install_symlink libexec/"bin/textffcut"
  end

  test do
    assert_match "textffcut", shell_output("#{bin}/textffcut --help 2>&1")
  end
end
