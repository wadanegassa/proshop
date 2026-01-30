import React from 'react';
import { AlertTriangle } from 'lucide-react';

class GlobalErrorBoundary extends React.Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false, error: null, errorInfo: null };
    }

    static getDerivedStateFromError(error) {
        return { hasError: true, error };
    }

    componentDidCatch(error, errorInfo) {
        console.error("Global Error Caught:", error, errorInfo);
        this.setState({ errorInfo });
    }

    render() {
        if (this.state.hasError) {
            return (
                <div style={styles.container}>
                    <div style={styles.card}>
                        <div style={styles.iconBox}>
                            <AlertTriangle size={48} color="var(--error)" />
                        </div>
                        <h2 style={styles.title}>Something went wrong</h2>
                        <p style={styles.message}>
                            An unexpected error occurred. Please try refreshing the page.
                        </p>
                        <details style={styles.details}>
                            <summary>Error Details</summary>
                            <pre style={styles.pre}>
                                {this.state.error && this.state.error.toString()}
                                <br />
                                {this.state.errorInfo && this.state.errorInfo.componentStack}
                            </pre>
                        </details>
                        <button
                            style={styles.button}
                            onClick={() => window.location.reload()}
                        >
                            Refresh Page
                        </button>
                    </div>
                </div>
            );
        }

        return this.props.children;
    }
}

const styles = {
    container: {
        height: '100vh',
        width: '100vw',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: '#09090b', // Hardcoded dark bg to match potential theme
        color: '#fff'
    },
    card: {
        background: '#18181b', // Zinc 900
        padding: '32px',
        borderRadius: '16px',
        maxWidth: '500px',
        width: '90%',
        textAlign: 'center',
        border: '1px solid #27272a'
    },
    iconBox: {
        background: 'rgba(239, 68, 68, 0.1)',
        width: '80px',
        height: '80px',
        borderRadius: '50%',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        margin: '0 auto 24px'
    },
    title: {
        fontSize: '24px',
        fontWeight: '800',
        marginBottom: '12px'
    },
    message: {
        color: '#a1a1aa',
        marginBottom: '24px',
        lineHeight: '1.5'
    },
    details: {
        textAlign: 'left',
        background: '#000',
        padding: '12px',
        borderRadius: '8px',
        marginBottom: '24px',
        fontSize: '12px',
        color: '#ef4444',
        overflow: 'auto',
        maxHeight: '200px'
    },
    pre: {
        whiteSpace: 'pre-wrap',
        marginTop: '8px'
    },
    button: {
        background: '#f97316', // Orange-500
        color: 'white',
        border: 'none',
        padding: '12px 24px',
        borderRadius: '8px',
        fontWeight: '700',
        cursor: 'pointer',
        fontSize: '14px'
    }
};

export default GlobalErrorBoundary;
