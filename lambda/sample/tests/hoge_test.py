import unittest
import os
import sys

# Add parent directory to the module search path
parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)

from lib.hoge import *

class HogeTest(unittest.TestCase):
    def setUp(self):
        # 初期化処理
        pass

    def tearDown(self):
        # 終了処理
        pass

    def test_hoge(self):
        self.assertEqual('hoge', hoge_function())


if __name__ == "__main__":
    unittest.main()
