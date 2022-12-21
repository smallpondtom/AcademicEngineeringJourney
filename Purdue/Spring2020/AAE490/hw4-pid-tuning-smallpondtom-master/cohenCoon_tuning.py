def get_time_near(t, y, point):
    tolerance_range = max(y) - min(y)

    for i in range(len(y)):

        tolerance = abs(y[i] - point)

        if tolerance < tolerance_range:
            my_t = t[i]
            tolerance_range = tolerance

    return my_t


def CohenCoon(t, y):
    k = y[-1]

    t63 = get_time_near(t, y, 0.632 * k)
    t28 = get_time_near(t, y, 0.28 * k)
    tau = 1.5 * (t63 - t28)
    L = 1.5 * (t28 - (t63 / 3))

    R = L / tau
    kp = 0.67 / k * (R + 0.185)
    Ti = 2.5 * L * ((1 + 0.185 * R) / (1 + 0.611 * R))
    Td = 0.37 * L / (1 + 0.185 * R)

    ki = kp / Ti
    kd = kp * Td

    return kp, ki, kd





