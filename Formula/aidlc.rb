class Aidlc < Formula
  desc "Initialize and update AIDLC governance files"
  homepage "https://github.com/shubhangtiwari/aidlc"
  url "https://github.com/shubhangtiwari/aidlc/archive/refs/tags/aidlc/v0.7.0.tar.gz"
  sha256 "fa362b240674f1f1a8fceffd159f3ffe83c8917c23c32ed6ee942acc224d8f87"
  license "MIT"

  depends_on "go" => :build

  def install
    cd "aidlc" do
      ldflags = "-s -w -X github.com/shubhangtiwari/aidlc/aidlc/internal/commands.Version=#{version}"
      system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/aidlc"
    end
  end

  test do
    assert_match "aidlc #{version}", shell_output("#{bin}/aidlc version")
  end
end
