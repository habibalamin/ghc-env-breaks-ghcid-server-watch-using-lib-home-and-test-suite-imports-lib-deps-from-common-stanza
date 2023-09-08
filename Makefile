.PHONY: all watch-server watch-server-broken watch-server-workaround-use-test-suite-home-unit watch-server-workaround-no-ghc-environment watch-test
.SILENT: all watch-server watch-server-broken watch-server-workaround-use-test-suite-home-unit watch-server-workaround-no-ghc-environment watch-test

all:
	cabal v2-build

watch-server: watch-server-broken

watch-server-broken:
	# Running this after running then closing (Ctrl-C) `watch-test`
	# causes the stack overflow mentioned in the README.
	cabal v2-exec -- \
	  ghcid --command ' \
	    cabal v2-repl \
	      library:libminimalrepro\
	      --ghc-option=-fdiagnostics-color=always \
	  ' \
	  --reload=src/lib \
	  --restart=minimal-reproduction.cabal \
	  --test MinimalRepro.Server.run

# Running this after running then closing (Ctrl-C) `watch-test` causes
# no discernable immediate issues. Unfortunately, it looks like it was
# a mistake by a developer and obscures the intention, necessitating a
# comment.
watch-server-workaround-use-test-suite-home-unit:
	cabal v2-exec -- \
	  ghcid --command ' \
	    cabal v2-repl \
	      test-suite:test-minimal-reproduction\
	      --ghc-option=-fdiagnostics-color=always \
	  ' \
	  --reload=src/lib \
	  --restart=minimal-reproduction.cabal \
	  --test MinimalRepro.Server.run

# Running this after running then closing (Ctrl-C) `watch-test` causes
# no discernable immediate issues. It doesn't look like a mistake, but
# it's still unclear why someone would unset the environment variable,
# or why Cabal would set it in the first place if it's seemingly not a
# ncessity, so again, the intention is obscure, and it necessitates an
# explanation by the developer. Of course, we know that we use Cabal's
# `v2-exec` to get access to the `$PATH` when running `ghcid`, and not
# necessarily for the environment file, but that's not obvious.
watch-server-workaround-no-ghc-environment:
	cabal v2-exec -- \
	  ghcid --command ' \
	    env -u GHC_ENVIRONMENT \
	      cabal v2-repl \
	        library:libminimalrepro\
	        --ghc-option=-fdiagnostics-color=always \
	  ' \
	  --reload=src/lib \
	  --restart=minimal-reproduction.cabal \
	  --test MinimalRepro.Server.run

watch-test:
	cabal v2-exec -- \
	  ghcid --command ' \
	    cabal v2-repl \
	      test-suite:test-minimal-reproduction \
	  ' \
	  --reload=src \
	  --restart=minimal-reproduction.cabal \
		--test Spec.main

test:
	cabal v2-test
