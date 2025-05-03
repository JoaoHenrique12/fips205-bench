import sys
import csv
import matplotlib.pyplot as plt

def plot_csv_data(csv_filepath, x_column, y_column, title="Data Plot", x_label="X-axis", y_label="Y-axis"):
    """
    Reads data from a CSV file, plots the points, and connects them with a line.

    Args:
        csv_filepath (str): The path to your CSV file.
        x_column (str): The header of the column containing the x-axis data.
        y_column (str): The header of the column containing the y-axis data.
        title (str, optional): The title of the plot. Defaults to "Data Plot".
        x_label (str, optional): The label for the x-axis. Defaults to "X-axis".
        y_label (str, optional): The label for the y-axis. Defaults to "Y-axis".
    """
    x_data = []
    y_data = []

    try:
        with open(csv_filepath, 'r', newline='') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                row = {key.strip(): value for key, value in row.items()}
                try:
                    x_data.append(float(row[x_column]))
                    y_data.append(float(row[y_column]))
                except ValueError:
                    print(f"Warning: Skipping row with non-numeric data in columns '{x_column}' or '{y_column}': {row}")
                except KeyError as e:
                    print(f"Error: Column '{e}' not found in the CSV file. Please check your column names.")
                    return

        if x_data and y_data:
            plt.figure(figsize=(8, 6))
            plt.plot(x_data, y_data, marker='o', linestyle='-', color='blue')
            plt.title(title)
            plt.xlabel(x_label)
            plt.ylabel(y_label)
            plt.grid(True)

            png_file = csv_filepath.split('.')[0] + '.png'
            plt.savefig(png_file)
        else:
            print("No valid data found in the CSV file to plot.")

    except FileNotFoundError:
        print(f"Error: CSV file not found at '{csv_filepath}'. Please check the file path.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def main(csv_file, prefix_title):
    x_column_name = ''
    y_column_name = ''
    with open(csv_file, 'r') as f:
        x_column_name, y_column_name = [v.strip() for v in f.readline().split(',')]

    # Graph infos

    ## title
    prefix = "Memory usage:" if prefix_title == 'mem' else "Processor usage:"
    sufix = csv_file.split(".")[0] # remove extension
    sufix = ' '.join([v.capitalize() for v in sufix.split('-')])
    sufix = ' '.join([v.capitalize() for v in sufix.split('_')])
    plot_title = f"{prefix} {sufix}"

    ## default value for x values are: input_<some>_<word>, next line remove input word and capitalize it
    x_axis_label = ' '.join([v.capitalize() for v in x_column_name.split('_')[1:]])

    ## default value for y values are: <some>_<word>_<value>, next line capitalize it
    y_axis_label = ' '.join([v.capitalize() for v in y_column_name.split('_')])

    plot_csv_data(csv_file, x_column_name, y_column_name, plot_title, x_axis_label, y_axis_label)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise ValueError(
            "Inform the csv_filename and if this is a mem or cpu graph;"
           +"i.e. python3 main.py some_file.csv mem"
        )
    main(sys.argv[1], sys.argv[2])
