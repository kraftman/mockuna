FROM henriquegemignani/busted

RUN luarocks install luacov
RUN luarocks install luacov-cobertura 