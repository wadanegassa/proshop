from fpdf import FPDF

def create_pdf(input_md, output_pdf):
    pdf = FPDF()
    pdf.set_auto_page_break(auto=True, margin=15)
    pdf.add_page()
    pdf.set_font("Helvetica", size=10)
    
    with open(input_md, 'r', encoding='utf-8') as f:
        text = f.read()

    # latin-1 cleanup to be safe
    text = text.encode('latin-1', 'replace').decode('latin-1')
    
    # Using write() instead of multi_cell to bypass line_break.py issues
    pdf.write(5, text)

    pdf.output(output_pdf)
    print(f"PDF created successfully: {output_pdf}")

if __name__ == "__main__":
    create_pdf("DOCUMENTATION.md", "PROJECT_DOCUMENTATION.pdf")
