import psutil
import platform
import tkinter as tk
from tkinter import ttk
import requests

# Function to get CPU temperature
def get_cpu_temperature():
    if platform.system() == "Linux":
        try:
            with open("/sys/class/thermal/thermal_zone0/temp") as file:
                temp = int(file.read()) / 1000.0
                return temp
        except FileNotFoundError:
            return None
    elif platform.system() == "Windows":
        try:
            import wmi
            w = wmi.WMI(namespace="root\\wmi")
            temperature_info = w.MSAcpi_ThermalZoneTemperature()
            for temp in temperature_info:
                return temp.CurrentTemperature / 10.0 - 273.15
        except ImportError:
            return None
    else:
        return None

# Function to update information
def update_info():
    max_frequency = psutil.cpu_freq().max
    cpu_usage = psutil.cpu_percent(interval=1)
    cpu_freq = psutil.cpu_freq().current
    cpu_cores = psutil.cpu_count(logical=False)
    cpu_logical_processors = psutil.cpu_count(logical=True)
    cpu_temp = get_cpu_temperature()

    memory_info = psutil.virtual_memory()
    memory_capacity = memory_info.total / (1024 ** 3)
    memory_usage = memory_info.percent

    disk_usage = psutil.disk_usage('/')
    storage_total = disk_usage.total / (1024 ** 3)
    storage_used = disk_usage.used / (1024 ** 3)
    storage_percent = disk_usage.percent

    usage_label.config(text=f"Uso: {cpu_usage}%")
    freq_label.config(text=f"Frequência atual: {cpu_freq:.2f} MHz")
    max_freq_label.config(text=f"Frequência máxima: {max_frequency} MHz")
    cores_label.config(text=f"Núcleos: {cpu_cores}")
    logical_label.config(text=f"Núcleos lógicos: {cpu_logical_processors}")
    temp_label.config(text=f"Temperatura: {cpu_temp:.2f}°C" if cpu_temp else "Não disponível")

    memory_capacity_label.config(text=f"Capacidade de memória: {memory_capacity:.2f} GB")
    memory_label.config(text=f"Uso de memória: {memory_usage:.2f}%")

    storage_total_label.config(text=f"Capacidade total de armazenamento: {storage_total:.2f} GB")
    storage_used_label.config(text=f"Uso de armazenamento: {storage_used:.2f} GB ({storage_percent}%)")

    obj_teste = {
        "processador_freq_atual": f"{cpu_freq:.2f}",
        "processador_freq_max": f"{max_frequency:.2f}",
        "processador_percentual": f"{cpu_usage:.2f}",
        "processador_temperatura": f"{cpu_temp:.2f}" if cpu_temp else "N/A",
        "memoria_capacidade": f"{memory_capacity:.2f}",
        "memoria_percentual": f"{memory_usage:.2f}",
        "armazenamento_capacidade": f"{storage_total:.2f}",
        "armazenamento_utilizado_percentual": f"{storage_percent:.2f}",
        "armazenamento_utilizado": f"{storage_used:.2f}"
    }

    if send_request_var.get() == 1:
        url = request_url_entry.get()
        if url:
            response = requests.post(url, json=obj_teste)
            print("\nStatus: " + str(response.status_code))
            print("Message: " + str(response.text))

    root.after(1000, update_info)


def check_inputs(*args):
    url = request_url_entry.get()
    if url:
        activate_button.grid(row=15, column=0, columnspan=2)
    else:
        activate_button.grid_forget()

root = tk.Tk()
root.title("Monitor")

mainframe = ttk.Frame(root, padding="10 14 10 14")
mainframe.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

cpu_header_label = ttk.Label(mainframe, text="Informações do processador", font=("times", 14))
cpu_header_label.grid(row=0, column=0, columnspan=2)

usage_label = ttk.Label(mainframe, text="Uso: ")
usage_label.grid(row=1, column=1, sticky=tk.W)
freq_label = ttk.Label(mainframe, text="Frequência atual: ")
freq_label.grid(row=2, column=1, sticky=tk.W)
max_freq_label = ttk.Label(mainframe, text="Frequência máxima: ")
max_freq_label.grid(row=3, column=1, sticky=tk.W)
cores_label = ttk.Label(mainframe, text="Núcleos: ")
cores_label.grid(row=4, column=1, sticky=tk.W)
logical_label = ttk.Label(mainframe, text="Núcleos lógicos: ")
logical_label.grid(row=5, column=1, sticky=tk.W)
temp_label = ttk.Label(mainframe, text="Temperatura: ")
temp_label.grid(row=6, column=1, sticky=tk.W)

memory_header_label = ttk.Label(mainframe, text="Informações da memória", font=("times", 14))
memory_header_label.grid(row=7, column=0, columnspan=2)
memory_capacity_label = ttk.Label(mainframe, text="Capacidade de memória: ")
memory_capacity_label.grid(row=8, column=1, sticky=tk.W)
memory_label = ttk.Label(mainframe, text="Uso de memória: ")
memory_label.grid(row=9, column=1, sticky=tk.W)

storage_header_label = ttk.Label(mainframe, text="Informações de armazenamento", font=("times", 14))
storage_header_label.grid(row=10, column=0, columnspan=2)
storage_total_label = ttk.Label(mainframe, text="Capacidade total de armazenamento: ")
storage_total_label.grid(row=11, column=1, sticky=tk.W)
storage_used_label = ttk.Label(mainframe, text="Uso de armazenamento: ")
storage_used_label.grid(row=12, column=1, sticky=tk.W)

request_url_label = tk.Label(mainframe, text='Endereço requisição', font=('calibre', 10, 'bold'))
request_url_label.grid(row=13, column=0, columnspan=2)
request_url_entry = tk.Entry(mainframe, width=45, font=('calibre', 10, 'normal'))
request_url_entry.grid(row=14, column=1)

send_request_var = tk.IntVar()
activate_button = ttk.Checkbutton(mainframe, text="Ativar envio de requisição", variable=send_request_var)
activate_button.grid(row=15, column=0, columnspan=2)

for child in mainframe.winfo_children():
    child.grid_configure(padx=5, pady=5)

root.after(0, update_info)

root.mainloop()
