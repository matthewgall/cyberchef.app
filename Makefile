VERSION:="v10.18.5"

.PHONY: download release
download:
	@echo Cleaning up public
	@rm -rf dist/ public/

	@echo Downloading Cyberchef: ${VERSION}
	@wget https://github.com/gchq/CyberChef/releases/download/${VERSION}/CyberChef_${VERSION}.zip

	@echo Extracting CyberChef
	@unzip "CyberChef_${VERSION}.zip" -d public
	@mv "public/CyberChef_${VERSION}.html" "public/index.html"
	@echo ${VERSION} > public/version
	@cat public/index.html | shasum -a 1 | grep -Eo "([a-z0-9]*)" > public/version.sha1
	@cat public/assets/main.js | shasum -a 256 | grep -Eo "([a-z0-9]*)" > public/version.sha256
	@cat public/modules/Serialise.js | shasum -a 512 | grep -Eo "([a-z0-9]*)" > public/version.sha512

	@echo Cleaning up artifacts
	@rm *.zip

release:
	@git add Makefile
	@git commit -m "RELEASE $(cat Makefile | grep "VERSION:=" | cut -d "=" -f 2 | sed 's/"//g')"
	@git push