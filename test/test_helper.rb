TEST_DIR = File.dirname(__FILE__)
LIB_DIR = File.join(TEST_DIR, '..', 'lib')

$LOAD_PATH.unshift(TEST_DIR) unless $LOAD_PATH.include?(TEST_DIR)
$LOAD_PATH.unshift(LIB_DIR) unless $LOAD_PATH.include?(LIB_DIR)

require 'test/unit'

