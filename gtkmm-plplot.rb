class GtkmmPlplot < Formula
  desc "Scientific plotting for Gtkmm3"
  homepage "https://tschoonj.github.io/gtkmm-plplot/"
  url "https://github.com/tschoonj/gtkmm-plplot/releases/download/gtkmm-plplot-2.5/gtkmm-plplot-2.5.tar.gz"
  sha256 "9db852627de074bb028045f32f450d4bf14ba968f6bbc0b5c27bac41ae4e1e9e"

  head do
    url "https://github.com/tschoonj/gtkmm-plplot.git"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "plplot"
  depends_on "boost" => :recommended

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "true"
  end
end
