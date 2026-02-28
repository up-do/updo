updo/Makefile:
	$(info Referencing Updo at $(UPDO_REF))
	rm -rf updo
	curl -sSL ${UPDO_ARCHIVE} | tar -xz
	mv updo-* updo
	chmod +x $$(grep -RIl '^#!' updo)
