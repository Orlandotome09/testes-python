from random import randint


firstProvider = "NEOWAY"
secondProvider = "SERASA"
thirdProvider = "SERPRO"


def generate_cnpj():
    def calculate_special_digit(l):
        digit = 0

        for i, v in enumerate(l):
            digit += v * (i % 8 + 2)

        digit = 11 - digit % 11

        return digit if digit < 10 else 0

    cnpj = [1, 0, 0, 0] + [randint(0, 9) for x in range(8)]

    for _ in range(2):
        cnpj = [calculate_special_digit(cnpj)] + cnpj

    return "%s%s%s%s%s%s%s%s%s%s%s%s%s%s" % tuple(cnpj[::-1])


def generate_cpf():
    cpf = [randint(0, 9) for x in range(9)]

    for _ in range(2):
        val = sum([(len(cpf) + 1 - i) * v for i, v in enumerate(cpf)]) % 11

        cpf.append(11 - val if val > 1 else 0)

    return "%s%s%s%s%s%s%s%s%s%s%s" % tuple(cpf)


def DocumentNormalizer():
    function(input)
    output = input.replace("/", "")
    output = output.replace(".", "")
    output = output.replace(".", "")
    output = output.replace("-", "")

    return output
