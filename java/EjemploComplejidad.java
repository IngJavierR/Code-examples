import java.util.Scanner;

public class EjemploComplejidad {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Ingrese un número:");
        int numero = scanner.nextInt();

        if (numero > 0) {
            System.out.println("El número es positivo.");

            if (numero < 100) {
                System.out.println("El número es menor que 100.");

                if (numero % 2 == 0) {
                    System.out.println("El número es par.");

                    if (numero % 4 == 0) {
                        System.out.println("El número es divisible por 4.");

                        if (numero % 5 == 0) {
                            System.out.println("El número es divisible por 5.");

                            if (numero > 50) {
                                System.out.println("El número es mayor que 50.");

                                if (numero % 10 == 0) {
                                    System.out.println("El número es múltiplo de 10.");
                                } else {
                                    System.out.println("El número no es múltiplo de 10.");
                                }
                            } else {
                                System.out.println("El número no es mayor que 50.");
                            }
                        } else {
                            System.out.println("El número no es divisible por 5.");
                        }
                    } else {
                        System.out.println("El número no es divisible por 4.");
                    }
                } else {
                    System.out.println("El número es impar.");

                    if (numero % 3 == 0) {
                        System.out.println("El número es divisible por 3.");

                        if (numero < 20) {
                            System.out.println("El número es menor que 20.");
                        } else {
                            System.out.println("El número no es menor que 20.");
                        }
                    } else {
                        System.out.println("El número no es divisible por 3.");
                    }
                }
            } else {
                System.out.println("El número es 100 o mayor.");
            }
        } else if (numero == 0) {
            System.out.println("El número es cero.");
        } else {
            System.out.println("El número es negativo.");

            if (numero % 2 == 0) {
                System.out.println("El número es negativo y par.");
            } else {
                System.out.println("El número es negativo e impar.");
            }
        }
    }
}
