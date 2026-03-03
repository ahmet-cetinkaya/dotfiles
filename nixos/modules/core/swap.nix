_: {
  # Enable zram - compressed RAM-based swap
  # More efficient than traditional swap: reduces disk I/O, improves performance
  zramSwap = {
    enable = true;
    # Use half of RAM as zram size (recommended default)
    memoryPercent = 50;
    # Use zstd compression algorithm (better compression ratio)
    algorithm = "zstd";
  };

  # Optional: Reduce swappiness to prefer RAM over swap
  # Lower values = less aggressive swapping (0-100)
  # For zram, higher values are acceptable since it's RAM-based
  boot.kernelParams = ["vm.swappiness=100"];
}
