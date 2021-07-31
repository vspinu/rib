
R = R

TWS_API_LIB_PATH ?=

install:
	$(R) CMD INSTALL .

clean:
	@./cleanup
