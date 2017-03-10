class GtkmmPlplot < Formula
  desc "Scientific plotting for Gtkmm3"
  homepage "https://tschoonj.github.io/gtkmm-plplot/"
  url "https://github.com/tschoonj/gtkmm-plplot/releases/download/gtkmm-plplot-2.2/gtkmm-plplot-2.2.tar.gz"
  sha256 "6b237b461bb205f92e49f744fbd22e4a2299c4b89439d04020117e8a204de3de"

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "plplot"
  depends_on "boost" => :recommended
  needs :cxx11

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
