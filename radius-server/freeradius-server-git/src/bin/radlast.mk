install: $(R)$(bindir)/radlast

$(R)$(bindir)/radlast: src/bin/radlast | $(R)$(bindir)
	@echo INSTALL $(notdir $<)
	@$(INSTALL) -m 755 $< $(R)$(bindir)
