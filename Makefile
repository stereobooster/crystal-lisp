STEPS = step0_repl.cr step1_read_print.cr step2_eval.cr step3_env.cr \
        step4_if_fn_do.cr step5_tco.cr step6_file.cr step7_quote.cr \
	step8_macros.cr step9_try.cr stepA_mal.cr

STEP1_DEPS = $(STEP0_DEPS) reader.cr printer.cr
STEP2_DEPS = $(STEP1_DEPS) types.cr
STEP3_DEPS = $(STEP2_DEPS) env.cr
STEP4_DEPS = $(STEP3_DEPS) core.cr error.cr

STEP_BINS = $(STEPS:%.cr=%)
LAST_STEP_BIN = $(word $(words $(STEP_BINS)),$(STEP_BINS))

all: $(STEP_BINS)

dist: mal

mal: $(LAST_STEP_BIN)
	cp $< $@

$(STEP_BINS): %: %.cr
	crystal build --release --error-trace $<

step0_repl: $(STEP0_DEPS)
step1_read_print: $(STEP1_DEPS)
step2_eval: $(STEP2_DEPS)
step3_env: $(STEP3_DEPS)
step4_if_fn_do step5_tco step6_file step7_quote step8_macros step9_try stepA_mal: $(STEP4_DEPS)

test-mal:
	python runtest.py tests/step0_repl.mal ./step0_repl
	# python runtest.py tests/step1_read_print.mal ./step1_read_print
	python runtest.py tests/step2_eval.mal ./step2_eval
	python runtest.py tests/step3_env.mal ./step3_env
	python runtest.py tests/step4_if_fn_do.mal ./step4_if_fn_do
	python runtest.py tests/step5_tco.mal ./step5_tco
	python runtest.py tests/step6_file.mal ./step6_file
	python runtest.py tests/step7_quote.mal ./step7_quote
	python runtest.py tests/step8_macros.mal ./step8_macros
	python runtest.py tests/step9_try.mal ./step9_try
	python runtest.py tests/stepA_mal.mal ./stepA_mal

clean:
	rm -rf $(STEP_BINS) mal .crystal

.PHONY: clean all test-mal default

default: clean all test-mal

.DEFAULT_GOAL := default
