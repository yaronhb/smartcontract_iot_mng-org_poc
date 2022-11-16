OPENSSL		= openssl

domain := example.com
password := whatever_pass

#uid			:= 1ab4
uid_4digs 	:= $(shell echo "$${uid:60:63}")

outdir		:= out
uid_outdir	:= $(outdir)/$(uid)

ca			:= $(uid_outdir)/ca_$(uid_4digs)
client			:= $(uid_outdir)/client_$(uid_4digs)
# export vars_EMPLOYEE_ID="$(uid)"
# export vars_DOMAIN="example.com"


######################################################################
#
#  Make the necessary files, but not client certificates.
#
######################################################################
.PHONY: all
all: ca client

.PHONY: client
client: "$(client).pem"

.PHONY: ca
ca:  "$(ca).pem" | init

.PHONY: verify
verify: ca.vrfy client.vrfy

.PHONY: init
init: $(uid_outdir) $(uid_outdir)/index.txt $(uid_outdir)/serial_no

######################################################################
#
#  Create a new self-signed CA certificate
#
######################################################################

"$(ca).cnf" : init
	@cat ca.cnf \
		| sed 's/$${ENV::vars_EMPLOYEE_ID}/$(uid)/' \
		| sed 's/$${ENV::vars_EMPLOYEE_ID_4DIGS}/$(uid_4digs)/' \
		| sed 's/$${ENV::vars_DOMAIN}/$(domain)/' \
		| sed 's/$${ENV::vars_PASSWORD}/$(password)/' \
		> "$(ca).cnf"

"$(ca).pem" "$(ca).key": "$(ca).cnf" | init
	$(OPENSSL) req -new -x509\
		-config "$(ca).cnf" \
		-out "$(ca).pem" \
		-keyout "$(ca).key"

# ca.der: ca.pem
# 	$(OPENSSL) x509 -inform PEM -outform DER -in ca.pem -out ca.der

.PHONY: ca.vrfy
ca.vrfy: "$(ca).pem"
	$(OPENSSL) verify -CAfile "$(ca).pem" "$(ca).pem"

# ca.crl: ca.pem
# 	$(OPENSSL) ca -gencrl -keyfile ca.key -cert ca.pem -config ./ca.cnf -out ca-crl.pem -key $(PASSWORD_CA)
# 	$(OPENSSL) crl -in ca-crl.pem -outform der -out ca.crl
# 	rm ca-crl.pem

######################################################################
#
#  Create a new client certificate, signed by the the above server
#  certificate.
#
######################################################################
"$(client).cnf" : init
	cat client.cnf \
		| sed 's/$${ENV::vars_EMPLOYEE_ID}/$(uid)/' \
		| sed 's/$${ENV::vars_EMPLOYEE_ID_4DIGS}/$(uid_4digs)/' \
		| sed 's/$${ENV::vars_DOMAIN}/$(domain)/' \
		| sed 's/$${ENV::vars_PASSWORD}/$(password)/' \
		> "$(client).cnf"

"$(client).csr" "$(client).key": "$(client).cnf"
	$(OPENSSL) req -new \
	  -out "$(client).csr" \
	  -keyout "$(client).key" \
	  -config "$(client).cnf"

"$(client).crt": "$(ca).key" "$(ca).pem" "$(client).csr"
	$(OPENSSL) ca -batch \
		-keyfile "$(ca).key" \
		-cert "$(ca).pem" \
		-in "$(client).csr"  \
		-key $(password) \
		-out "$(client).crt" \
		-extensions xpclient_ext \
		-extfile xpextensions \
		-config "$(client).cnf"

# client.p12: client.crt
# 	$(OPENSSL) pkcs12 -export -in client.crt -inkey client.key -out client.p12  -passin pass:$(PASSWORD_CLIENT) -passout pass:$(PASSWORD_CLIENT)
# 	chmod g+r client.p12
# 	cp client.p12 $(USER_NAME).p12

"$(client).pem": "$(client).crt"
	$(OPENSSL) x509 \
	-inform PEM \
	-outform PEM \
	-in "$(client).crt" \
	-out "$(client).pem"

# .PHONY: client.vrfy
# client.vrfy: ca.pem client.pem
# 	# c_rehash .
# 	$(OPENSSL) verify -CAfile ca.pem client.pem

######################################################################
#
#  Miscellaneous rules.
#
######################################################################
$(uid_outdir):
	@mkdir -p $(uid_outdir)

$(uid_outdir)/index.txt:
	@touch $(uid_outdir)/index.txt

$(uid_outdir)/serial_no:
	@echo '01' > $(uid_outdir)/serial_no

# print:
# 	$(OPENSSL) x509 -text -in server.crt

printca:
	$(OPENSSL) x509 -text -in ca.pem

clean:
	@rm -f *~ *old client.csr client.key client.crt client.p12 client.pem

#
#	Make a target that people won't run too often.
#
destroycerts:
	# rm -rf *~ dh *.csr *.crt *.p12 *.der *.pem *.key index.txt* \
	# 		serial_no*  *\.0 *\.1 ca-crl.pem ca.crl out
	rm -r out
