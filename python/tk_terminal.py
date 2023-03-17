import tkinter as tk
import subprocess

class Application(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.create_widgets()

    def create_widgets(self):
        self.input_label = tk.Label(self.master, text="Enter command:")
        self.input_label.pack()
        self.input_entry = tk.Entry(self.master)
        self.input_entry.pack()
        self.result_text = tk.Text(self.master)
        self.result_text.pack()
        self.command_proc = subprocess.Popen(["perl", "../perl/shell.pl"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        self.after(100, self.read_output)

    def read_output(self):
        if self.command_proc.poll() is None:
            output = self.command_proc.stdout.readline()
            if output:
                self.result_text.insert(tk.END, output.decode())
        self.after(100, self.read_output)

    def send_command(self):
        command = self.input_entry.get()
        self.input_entry.delete(0, tk.END)
        self.result_text.insert(tk.END, "$ " + command + "\n")
        self.command_proc.stdin.write((command + '\n').encode())
        self.command_proc.stdin.flush()

root = tk.Tk()
app = Application(master=root)
send_button = tk.Button(root, text="Send", command=app.send_command)
send_button.pack()
app.mainloop()