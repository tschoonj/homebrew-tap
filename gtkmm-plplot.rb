class GtkmmPlplot < Formula
  desc "Scientific plotting for Gtkmm3"
  homepage "https://tschoonj.github.io/gtkmm-plplot/"
  url "https://github.com/tschoonj/gtkmm-plplot/releases/download/gtkmm-plplot-2.4/gtkmm-plplot-2.4.tar.gz"
  sha256 "f53d2352d6c77b02dbda4d77e18256b843edf70e7405ebf5a06512547eb4c770"
  revision 1

  head do
    url "https://github.com/tschoonj/gtkmm-plplot.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "mm-common" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "plplot"
  depends_on "boost" => :recommended

  def install
    if build.head?
      system "autoreconf", "-i"
    end

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
