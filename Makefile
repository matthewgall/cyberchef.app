VERSION:="v9.21.0"

.PHONY: download
download:
	@echo Cleaning up public
	@rm -rf dist/ public/

	@echo Downloading Cyberchef: ${VERSION}
	@wget https://github.com/gchq/CyberChef/releases/download/${VERSION}/CyberChef_${VERSION}.zip

	@echo Extracting CyberChef
	@unzip "CyberChef_${VERSION}.zip" -d public
	@mv "public/CyberChef_${VERSION}.html" "public/index.html"
	@cat public/index.html | shasum -a 512 | grep -Eo "([a-z0-9]*)" > public/version.sha512
	
	@echo Modifying CyberChef
	@rm public/assets/tesseract/lang-data/eng.traineddata.gz
	@wget -O public/assets/tesseract/lang-data/eng.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/master/eng.traineddata
	@gzip public/assets/tesseract/lang-data/eng.traineddata

	@echo Cleaning up artifacts
	@rm *.zip