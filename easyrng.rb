class Easyrng < Formula
  desc "Random number generators and distributions for C and Fortran"
  homepage "https://tschoonj.github.io/easyRNG"
  url "https://easyrng.tomschoonjans.eu/easyRNG-1.1.tar.gz"
  sha256 "dd85fc845a5f7e99c71ff440888357304dec938d7be40e5ee4400272d2cb5a41"

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
