class GtkmmPlplot < Formula
  desc "Scientific plotting for Gtkmm3"
  homepage "https://tschoonj.github.io/gtkmm-plplot/"
  url "http://lvserver.ugent.be/gtkmm-plplot/gtkmm-plplot-2.1.tar.gz"
  sha256 "24592243c3ebca5e50515464f34d0e2b291b8141389cf5e483c91da7b2b75a0a"

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
