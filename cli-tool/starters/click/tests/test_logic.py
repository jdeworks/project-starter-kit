from src.logic import greet_message, count_sequence


def test_greet_message_returns_greeting():
    assert greet_message("Alice") == "Hello, Alice!"


def test_greet_message_with_spaces():
    assert greet_message("Bob Smith") == "Hello, Bob Smith!"


def test_greet_message_empty_string():
    assert greet_message("") == "Hello, !"


def test_count_sequence_basic():
    assert count_sequence(5) == [1, 2, 3, 4, 5]


def test_count_sequence_one():
    assert count_sequence(1) == [1]


def test_count_sequence_large():
    result = count_sequence(100)
    assert len(result) == 100
    assert result[0] == 1
    assert result[-1] == 100
