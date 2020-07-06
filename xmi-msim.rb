class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-8.1.tar.gz"
  sha256 "15f011acf8de9bcd64103aae4054d00e4731c6ce2a16a5724039be0e6de1b66d"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "easyrng"
  depends_on "gcc"
  depends_on "glib"
  depends_on "hdf5"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "xraylib"
  depends_on "libsoup"
  depends_on "gtkmm-plplot"
  depends_on "libpeas"

  def install
    ENV.deparallelize # fortran modules don't like parallel builds

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-gui",
                          "--disable-updater"
    system "make", "install"
  end

  def post_install
    ohai "Generating xmimsimdata.h5 – this may take a while"
    mktemp do
      system bin/"xmimsim-db"
      (share/"xmimsim").install "xmimsimdata.h5"
    end
  end

  test do
    system bin/"xmimsim", "--version"
  end
end
