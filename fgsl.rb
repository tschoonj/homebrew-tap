class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://doku.lrz.de/download/attachments/43321199/fgsl-1.3.0.tar.gz"
  sha256 "e4ece7600073be16a08bd3450629c2b1198716505cf5fd3365062e0b5c53a142"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "gsl"

  patch do
    url "https://github.com/reinh-bader/fgsl/commit/c306e9f936983df5bab68f8ba55006c0f88bc775.diff"
    sha256 "7d826e7d1c28791f5f314be98976e664196ea11182cfb6d3e059ac33828c587b"
  end

  def install
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    ENV.fortran
    system ENV.fc, "#{share}/examples/fgsl/fft.f90",
                   "-L#{lib}", "-lfgsl", "-I#{include}/fgsl", "-o", "test"
    system "./test"
  end
end
