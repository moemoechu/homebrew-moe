class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/jinfeihan57/p7zip"
  url "https://github.com/jinfeihan57/p7zip/archive/v17.03.tar.gz"
  sha256 "bb4b9b21584c0e076e0b4b2705af0dbe7ac19d378aa7f09a79da33a5b3293187"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  # Remove non-free RAR sources
  patch :DATA

  # Fix AES security bugs
  # https://github.com/jinfeihan57/p7zip/pull/117
  patch do
    url "https://github.com/jinfeihan57/p7zip/commit/6106df26ff64fa8147bfc9abdc0a14908b5d3871.patch?full_index=1"
    sha256 "5fcce7293ba017b4aa3ba5afbe6f2a847d60a785ea0966c31ac33da4bdf3ef6e"
  end

  def install
    mv "makefile.macosx_llvm_64bits", "makefile.machine"
    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7z", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7z", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath/"out/foo.txt")
  end
end

__END__
diff -u -r a/makefile b/makefile
--- a/makefile	2021-02-21 14:27:14.000000000 +0800
+++ b/makefile	2021-02-21 14:27:31.000000000 +0800
@@ -31,7 +31,6 @@
 	$(MAKE) -C CPP/7zip/UI/Client7z           depend
 	$(MAKE) -C CPP/7zip/UI/Console            depend
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree  depend
 	$(MAKE) -C CPP/7zip/UI/GUI                depend
 	$(MAKE) -C CPP/7zip/UI/FileManager        depend
 
@@ -42,7 +41,6 @@
 common7z:common
 	$(MKDIR) bin/Codecs
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree all
 
 lzham:common
 	$(MKDIR) bin/Codecs
@@ -67,7 +65,6 @@
 	$(MAKE) -C CPP/7zip/UI/FileManager       clean
 	$(MAKE) -C CPP/7zip/UI/GUI               clean
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree clean
 	$(MAKE) -C CPP/7zip/Compress/Lzham       clean
 	$(MAKE) -C CPP/7zip/Bundles/LzmaCon      clean2
 	$(MAKE) -C CPP/7zip/Bundles/AloneGCOV    clean