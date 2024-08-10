class GtkmmPlplot < Formula
  desc "Scientific plotting for Gtkmm4"
  homepage "https://tschoonj.github.io/gtkmm-plplot/"
  url "https://github.com/tschoonj/gtkmm-plplot/releases/download/gtkmm-plplot-3.0/gtkmm-plplot-3.0.tar.xz"
  sha256 "5e345a97abdcde08dd74b5a43d7f07840c0e082537cdc0345f60a02e4b700bfc"

  head do
    url "https://github.com/tschoonj/gtkmm-plplot.git"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtkmm4"
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
