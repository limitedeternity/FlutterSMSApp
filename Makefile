all:
	rm -rf build/
	flutter build apk --split-per-abi --target-platform android-arm,android-arm64,android-x64 --release --tree-shake-icons --shrink --obfuscate --split-debug-info=./debug-info/

