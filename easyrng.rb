class Easyrng < Formula
  desc "Random number generators and distributions for C and Fortran"
  homepage "https://tschoonj.github.io/easyRNG"
  url "https://easyrng.tomschoonjans.eu/easyRNG-1.0.tar.gz"
  sha256 "aaf5aab330a484199b068285716bb7d493c7cf1f50ef0e0a0992fce6716cadd6"

  depends_on :fortran => [:build, :recommended]
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
