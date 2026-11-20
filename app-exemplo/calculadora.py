import os


def soma(a, b):
    resultado = a + b
    return resultado


def divide(a, b):
    return a / b


def media(numeros):
    total = 0
    for n in numeros:
        total = total + n
    return total / len(numeros)


def senha_fixa():
    senha = "admin123"
    return senha


def comando_inseguro(entrada):
    os.system("echo " + entrada)


def main():
    print(soma(2, 3))
    print(divide(10, 2))
    print(media([1, 2, 3, 4]))
    print(senha_fixa())
    comando_inseguro("teste")


if __name__ == "__main__":
    main()
