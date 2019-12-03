class GtkmmPlplot < Formula
  desc "Scientific plotting for Gtkmm3"
  homepage "https://tschoonj.github.io/gtkmm-plplot/"
  url "https://github.com/tschoonj/gtkmm-plplot/releases/download/gtkmm-plplot-2.3/gtkmm-plplot-2.3.tar.gz"
  sha256 "db2415199b19f3c796000071ba63c3a9e979b8c62a4188777dc06bdee7c44d5d"
  head "https://github.com/tschoonj/gtkmm-plplot.git"

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "plplot"
  depends_on "boost" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
